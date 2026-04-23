--心を見通す眼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.picon)
	e2:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e2)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_DRAW+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetCondition(s.picon2)
	e5:SetOperation(s.piop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_SSET)
	e6:SetCondition(s.picon)
	e6:SetOperation(s.piop2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_MSET)
	c:RegisterEffect(e7)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x62)
end
function s.picon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.cfilter2(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TOON)
end
function s.cfilter3(c)
	return c:IsFaceupEx() and c:IsSetCard(0x62) and c:IsType(TYPE_SPELL)
end
function s.discon(e)
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter3,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local g=Group.CreateGroup()
		for i=1,ch-1 do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			g:AddCard(te:GetHandler())
		end
		local codes={}
		local ag=Group.CreateGroup()
		for c in aux.Next(g) do
			local code=c:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(c)
				table.insert(codes,code)
			end
		end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			--or ... or c:IsCode(codes[i])
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		table.insert(afilter,OPCODE_NOT)
		ag:Clear()
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	else
		local ac=Duel.AnnounceCard(tp)
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetCondition(s.discon1)
		e1:SetOperation(s.disop1)
		e1:SetLabel(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local c=e:GetHandler()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function s.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.picon2(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():GetFlagEffect(id)==0
end
function s.filter(c)
	return c:IsFacedown()
end
function s.piop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.piop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(Card.IsControler,nil,1-e:GetHandlerPlayer())
	Duel.ConfirmCards(tp,sg)
end