--ヴァルモニカの神異－ゼブフェーラ
function c100421034.initial_effect(c)
	c:SetSPSummonOnce(100421034)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c100421034.spcost)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100421034.reptg)
	e2:SetValue(c100421034.repval)
	e2:SetOperation(c100421034.repop)
	c:RegisterEffect(e2)
	--copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100421034,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100421034.cpcon)
	e3:SetTarget(c100421034.cptg)
	e3:SetOperation(c100421034.cpop)
	c:RegisterEffect(e3)
end
function c100421034.spcfilter(c)
	return c:IsFaceup() and c:GetOriginalRace()==RACE_FIEND and c:GetCounter(0x16a)>=3
end
function c100421034.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(c100421034.spcfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c100421034.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100421034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c100421034.repfilter,1,nil,tp)
		and Duel.IsCanRemoveCounter(tp,1,0,0x16a,3,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c100421034.repval(e,c)
	return c100421034.repfilter(c,e:GetHandlerPlayer())
end
function c100421034.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x16a,3,REASON_EFFECT)
end
function c100421034.cpfilter(c)
	return c:IsSetCard(0x2a3) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c100421034.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100421034.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c100421034.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100421034.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100421034.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c100421034.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local te=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end