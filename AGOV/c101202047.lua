--ペンデュラム・エボリューション
function c101202047.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Search 1 Pendulum Monster with 2500 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202047,0))
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101202047)
	e1:SetCost(c101202047.thcost)
	e1:SetTarget(c101202047.thtg)
	e1:SetOperation(c101202047.thop)
	c:RegisterEffect(e1)
	--Perform a Pendulum Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202047,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101202047+100)
	e2:SetCondition(c101202047.pencon)
	e2:SetTarget(c101202047.pentg)
	e2:SetOperation(c101202047.penop)
	c:RegisterEffect(e2)
	--Make 1 "Supreme King Z-ARC" you control able to attack all monsters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202047,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101202047+200)
	e3:SetCondition(c101202047.atkcon)
	e3:SetTarget(c101202047.atktg)
	e3:SetOperation(c101202047.atkop)
	c:RegisterEffect(e3)
	if not c101202047.global_check then
		c101202047.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c101202047.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101202047.checkop(e,tp,eg,ep,ev,re,r,rp)
	local sumpl=nil
	for tc in aux.Next(eg) do
		sumpl=tc:GetSummonPlayer()
		if tc:IsSummonLocation(LOCATION_EXTRA) and tc:IsType(TYPE_PENDULUM) and tc:IsPreviousPosition(POS_FACEDOWN)
			and tc:IsFaceup() and sumpl==tc:GetOwner() then
			Duel.RegisterFlagEffect(sumpl,101202047,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c101202047.PConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
end
function c101202047.PendCondition(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,101202047)}
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(c101202047.PConditionFilter,1,nil,e,tp,lscale,rscale)
end
function c101202047.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,101202047)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(c101202047.PConditionFilter,nil,e,tp,lscale,rscale)
				else
					tg=Duel.GetMatchingGroup(c101202047.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
				end
				local ce=nil

				if ce then
					tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
end
function c101202047.thcfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c101202047.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101202047.thfilter(c,code)
	return c:IsType(TYPE_PENDULUM) and c:IsAttack(2500) and not c:IsCode(code) and c:IsAbleToHand()
end
function c101202047.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202047.thcfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c101202047.thcfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
	e:SetLabel(tc:GetCode())
end
function c101202047.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101202047.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101202047.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101202047.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101202047)>0
end
function c101202047.check(e,tp,exc)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,exc,TYPE_MONSTER)
	if #g==0 then return false end
	return c101202047.PendCondition(e,lpz,g)
end
function c101202047.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c101202047.check(e,tp,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c101202047.penop(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_MONSTER)
	if #g==0 then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	c101202047.PendOperation(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
end
function c101202047.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c101202047.atkfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c101202047.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101202047.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202047.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101202047.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101202047.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--Can attack all your opponent's monsters, once each
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end